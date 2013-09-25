desc "This task is called by the Heroku scheduler add-on"

task :take_phase_snapshots => :environment do
  puts "Taking phase snapshots..."
  PhaseSnapshot.take_all_snapshots
  puts "done."
end
