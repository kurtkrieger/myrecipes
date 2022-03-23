namespace :cron do
  
  ###########################################################################
  
  def show_help(msg)
    puts "help: #{msg}"
    exit 1
  end
  
  ###########################################################################
  
  def list_specs(report_specs,msg)
    max_report_name_len = 0
    max_email_len = 0
    
    puts "\n#{msg}\n\n"
    
    report_names = report_specs.map{|spec| spec[:report][:name]}
    max_report_name_len = [max_report_name_len,report_names.max_by(&:length).length].max
    
    report_names.uniq.sort.each do |rep_name|
      puts "#{rep_name}"
      email_targets = report_specs.select{|spec| spec[:report][:name] == rep_name}
      email_targets.each do |tgt|
        emails = tgt[:report][:emails]
        max_email_len = [max_email_len,emails.max_by(&:length).length].max
        emails.sort.each do |em|
          puts "\t#{em}"
        end
      end
    end
    puts""
    
    {max_report_name_len: max_report_name_len + 2, max_email_len: max_email_len + 2}
  end

  ###########################################################################

  def show_db_counts(msg)
    puts "Current database counts #{msg}..."
    puts "Servers                 : #{Lookup.where(lookup_type: 'server').count}"
    puts "Cronreports             : #{Cronreport.count}"
    puts "Cronreport_distributions: #{Cronreport_distribution.count}"
    puts ""
  end

  ###########################################################################
  
  desc "Populate cronreport tables for one server"
  task :populate_cronreports, [:server,:action,:save,:emails] => :environment do |t, args|
    

    begin
      
      puts "\nExecuting rake task 'cron:populate_cronreports'...\n\n"
      
      server_arg = (args[:server] || '')
      action_arg = (args[:action] || 'list').downcase
      
      save_arg   = (args[:save]   || 'false').downcase
      emails_arg = (args[:emails] || '').split(' ')
      
      puts "server_arg: '#{server_arg}'"
      puts "action_arg: '#{action_arg}'"
      puts "save_arg:   '#{save_arg}'"
      puts "emails_arg: '#{emails_arg}'"
      puts ""
      
      # Validate input arguments

      show_help(args,'Missing value for agrument 1: server')  if     server_arg.blank?
      show_help(args,'Bad value for agrument 2: action')      unless ['list','install','replace'].include?(action_arg)
      show_help(args,'Bad value for agrument 3: dryrun')      unless ['true','false'].include?(save_arg)
      show_help(args,'Missing replacement email address(es)') if     action_arg == 'replace' && emails_arg.count.zero?
      
      json_file_dir = File.dirname(__FILE__)
      
      json_filename = File.join(json_file_dir, "#{server_arg}.json")
      json_string = File.read(json_filename)

      begin
        parsed_json = JSON.parse(json_string)
      rescue JSON::ParserError => e  
        show_help "\nERROR: The content of this file is not valid JSON:\n\t#{json_filename}\n\t#{e}"
      end
      
      # For some reason iteration of the JSON array fails unless we convert each string
      # hash into a hash-with_indifferent_access. I'd like to figure how to avoid this
      # odd transform.
      report_specs = []
      parsed_json.each do |spec|
        report_specs << spec.with_indifferent_access
      end
      
      if action_arg != 'list'
        if save_arg == 'true'
          puts "NOTE: Because save_arg = '#{save_arg}', changes WILL be saved."
        else
          puts "NOTE: Because save_arg = '#{save_arg}', changes will NOT be saved."
        end
      end
      
      if ['list','install'].include?(action_arg) && !emails_arg.count.zero?
        puts "NOTE: Because action_arg = '#{action_arg}', emails #{emails_arg} will be IGNORED."
      end
      
      # Display the original list
      max_attr_lens = (list_specs(report_specs, "Report records for server '#{server_arg}', from file:")) if ['list','install'].include?(action_arg)

      exit 0 if action_arg == 'list'
      
      # Replace the current email addresses with the list of emails passed in to task,
      # then display the new list.
      if action_arg == 'replace'
        report_specs.each do |spec|
          spec[:report][:emails] = emails_arg
        end
        max_attr_lens = list_specs(report_specs, "Report records, after replacing email addresses:")
      end
      
      Cronreport.destroy_all
      Cronreport_distribution.destroy_all
      
      show_db_counts("BEFORE transaction")
      
      # Perform the databases changes, rolling back if configured to.
      puts "\nExecuting statements in transaction...\n\n"
    
      ActiveRecord::Base.transaction do
        begin
          
          found_bad_email = false
          
          report_specs.each do |spec|
            lk = Lookup.find_or_create_by(lookup_type: 'server', short_name: server_arg)
            report = spec[:report]
            rep = Cronreport.find_or_create_by(lookup_id: lk[:id], name: report[:name])
            Cronreport_distribution.where(cronreport_id: rep[:id]).destroy_all if action_arg == 'replace'
            report[:emails].each do |em|
              user = User.find_by(email: em)
              if user.nil?
                report_name = "'#{report[:name]}'".ljust(max_attr_lens[:max_report_name_len],' ')
                address     = "'#{em}'".ljust(max_attr_lens[:max_email_len],' ')
                puts "WARNING: In report #{report_name} the email address #{address} was not found in the 'users' table!"
                found_bad_email = true
              else
                Cronreport_distribution.find_or_create_by(cronreport_id: rep[:id], user_id: user[:id])
              end
            end
          end
          
          puts "" if found_bad_email
          
          show_db_counts("INSIDE transaction after changes were made")
      
          # Roll back transaction, if configured to.
          if save_arg == 'true'
            puts "\nNOTE: Transaction was committed because save_arg = '#{save_arg}'."
          else
            raise ActiveRecord::Rollback
            puts "\nNOTE: Transaction was rolled back because save_arg = '#{save_arg}'."
          end
          
        rescue Exception => e
          raise ActiveRecord::Rollback
          puts "\nERROR: Transaction was rolled back: #{e.message}\n"
        end
      end
      
      puts ""
      
      show_db_counts("AFTER transaction")
      
    rescue StandardError => e
      puts "\nERROR: generic error '#{e}'\n\n"
    end
  end
end