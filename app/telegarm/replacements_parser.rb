require 'nokogiri'
require 'open-uri'

# Search second table(table with replacements) in the page and parse it to ruby hash
class ReplacementsParser
  def self.parse(url)
    replacements_table = Nokogiri::HTML.parse(URI.open(url)).css('table.bcol.w100')[1]
    return 'No replacements' if replacements_table.nil?

    replacements_rows = replacements_table.css('tr')[1..]

    replacements = {}
    current_day = ''
    replacements_rows.each do |row|
      cols = row.css 'td'

      case cols.size
      when 1
        current_day = cols[0].text
        replacements[current_day] = []
      when 3
        replacements[current_day] << {
          type: 'Отмена',
          pair_num: cols[1].text
        }
      when 5
        replacements[current_day] << {
          type: 'Замена',
          pair_num: cols[1].text,
          subject: cols[2].text,
          teacher: cols[3].text,
          cabinet: cols[4].text
        }
      else
        replacements[current_day] << {
          type: :unknown_row
        }
      end
    end
    replacements
  end

  def self.parse_to_string(url)
    data = parse(url)
    str = ''
    return 'Замен нет' if data == 'No replacements'

    data.each do |day, replacements|
      str += "=== #{day} ===\n"
      replacements.each do |replacement|
        str += "-- #{replacement[:type]} --\n"
        str += "Номер пары: #{replacement[:pair_num]}\n"
        str += "Предмет: #{replacement[:subject]}\n" if replacement[:subject]
        str += "Препод: #{replacement[:teacher]}\n" if replacement[:teacher]
        str += "Кабинет: #{replacement[:cabinet]}\n" if replacement[:cabinet]
      end
      str += "\n"
    end
    str
  end
end