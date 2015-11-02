require 'mechanize'
require 'colorize'
require 'pry'

module LectorsProber
  class Prober
    LECTORS_INDEX_URL = 'http://bsuir-helper.ru/lectors'
    LECTOR_URL_FORMAT = 'http://bsuir-helper.ru%s'
    SCHEDULE_URL_FORMAT = 'http://www.bsuir.by/schedule/schedule.xhtml?id=%s'
    SEPARATOR = '======='.red

    def initialize(num_group)
      @num_group = num_group
    end

    def find_lectors
      agent = Mechanize.new
      lectors = []
      work_page = agent.get(format(SCHEDULE_URL_FORMAT, @num_group))
      work_page.links.each do |link|
        lectors.push(link.text[0...-4])
      end
      lectors.uniq!
      lectors.pop(5)
      lectors.shift(3)
      find_comments(lectors)
    rescue
      raise 'Group not found or unable to connect to the internet.Try again.'
    end

    def find_comments(lectors)
      agent = Mechanize.new
      lectors_info = []
      work_page = agent.get(LECTORS_INDEX_URL)
      (work_page / '.views-row').each do |lector_link|
        comments = []
        lectors.each do |lector_name|
          next unless /#{lector_name}/ =~ lector_link.text
          name = lector_link.text
          lector_path = lector_link.at('a/@href').value
          lector_page = agent.get(format(LECTOR_URL_FORMAT, lector_path))
          (lector_page / 'div.comment/div.content/p').each do |comment|
            comments << "#{comment.children}".delete('<br>')
          end
          lectors_info << { name: name, comments: comments }
        end
      end
      lectors_info
    rescue
      raise 'Comment not found or unable to connect to the internet.Try again.'
    end

    def to_s
      lectors = find_lectors
      lectors_info = ''
      lectors.each do |lector|
        lectors_info << "#{lector[:name]}\n#{SEPARATOR}\n\n"
        lector[:comments].each { |com| lectors_info << "#{com}\n\n" }
      end
      lectors_info
    end
  end
end
