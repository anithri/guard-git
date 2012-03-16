require 'term/ansicolor'
module GritRepoExtension

  SUMMARY_FORMAT = {changed: [:yellow, '~'], added: [:green, '+'], deleted: [:red, '-'], untracked: [:blue, '?']}

  def status_summary
    status = self.status
    out = ""
    total = 0
    SUMMARY_FORMAT.each do |type, options|
      count = status.send(type).count
      next unless count > 0
      total += count
      out << [::Term::ANSIColor.send(options[0]), options[1], count, Term::ANSIColor.reset, " "].join("")
    end
    status_color = case
                   when total == 0
                     ::Term::ANSIColor.green
                   when total < 6
                     ::Term::ANSIColor.yellow
                   else
                     ::Term::ANSIColor.red
                   end
    out = out.empty? ? "Clean!" : out
    status_color + "Git Status: " + ::Term::ANSIColor.reset + out
  end
end
