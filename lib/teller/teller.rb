require 'mechanize'
require 'colorize'

module TeacherTeller
  class Teller
    def initialize(num_group)
      @num_group = num_group
    end

    def find_teachers
      agent = Mechanize.new
      teachers = []
      work_page =
       agent.get("http://www.bsuir.by/schedule/schedule.xhtml?id=#{@num_group}")
      work_page.links.each do |link|
        teachers.push(link.text[0...-4])
      end
      teachers.uniq!
      teachers.pop(5)
      teachers.shift(3)
      find_comments(teachers)
    end

    def find_comments(teachers)
      agent = Mechanize.new
      teachers_info = []
      work_page = agent.get('http://bsuir-helper.ru/lectors')
      (work_page / '.views-row').each do |teacher_link|
        comments = []
        teachers.each do |teacher_name|
          next unless /#{teacher_name}/ =~ teacher_link.text
          name = "#{teacher_link.text}"
          tmp_link =
          agent.get("http://bsuir-helper.ru#{teacher_link.at('a/@href').value}")
          (tmp_link / 'div.comment/div.content/p').each do |com|
            comments << "#{com.children}".delete('<br>')
          end
          teachers_info << { name: name, comments: comments }
        end
      end
      teachers_info
    end

    def to_s
      teachers = find_teachers
      separator = '======='.red
      teachers_info = ''
      teachers.each do |teacher|
        teachers_info << teacher[:name] + "\n" + separator + "\n" * 2
        teacher[:comments].each { |com| teachers_info << com + "\n" * 2 }
      end
      teachers_info
    end
  end
end
