#!/usr/bin/env ruby
require 'mechanize'

group_num = '322402'
agent = Mechanize.new
teachers = []

work_page = agent.get('https://www.google.by')
search_form = work_page.form_with name: 'f'
search_form.q = "Расписание БГУИР #{group_num}"
work_page = agent.submit(search_form)
work_page = work_page.link_with(text:
"#{group_num} - Расписание занятий для студентов БГУИР").click
work_page.links.each do |link|
  teachers.push(link.text[0...-4])
end
teachers.uniq!
teachers.pop(4)
teachers.shift(3)
# puts teachers
work_page = agent.get('http://bsuir-helper.ru/lectors')
(work_page / '.views-row').each do |teacher_link|
  teachers.each do |teacher_name|
    next unless teacher_link.text.include?("#{teacher_name}")
    puts "#{teacher_link.text} \n"
    tmp_link =
      agent.get("http://bsuir-helper.ru#{teacher_link.at('a/@href').value}")
    (tmp_link / 'div.comment/div.content/p').each do |com|
      puts "#{com.to_s.delete '</p>' '<br>'} \n"
    end
  end
end
puts "\nВсе учителя: \n\n"
puts teachers
