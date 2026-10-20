demo  = User.find_or_create_by!(email: "demo@example.com")  { |u| u.password = "password123" }
User.find_or_create_by!(email: "demo2@example.com") { |u| u.password = "password123" }

today = Date.current
[
  { title: "International Conference on Software Engineering & AI", location: "Москва, Россия",
    is_scopus: true, is_elibrary: true, start: 60, deadline: 30,
    description: "Методы искусственного интеллекта и программной инженерии." },
  { title: "Всероссийский симпозиум по высокопроизводительным вычислениям", location: "Санкт-Петербург, Россия",
    is_scopus: false, is_elibrary: true, start: 45, deadline: 20,
    description: "Суперкомпьютерные технологии и параллельное программирование." },
  { title: "Конференция по кибербезопасности и сетевым технологиям", location: "Казань, Россия",
    is_scopus: true, is_elibrary: false, start: 40, deadline: 10,
    description: "Информационная безопасность, криптография, защита данных." }
].each do |c|
  Conference.find_or_create_by!(title: c[:title]) do |conf|
    conf.description = c[:description]
    conf.location = c[:location]
    conf.is_scopus = c[:is_scopus]
    conf.is_elibrary = c[:is_elibrary]
    conf.start_date = today + c[:start]
    conf.end_date = today + c[:start] + 2
    conf.submission_deadline = today + c[:deadline]
    conf.website_url = "https://example.com"
    conf.creator = demo
    conf.status = :published
  end
end

puts "Конференций: #{Conference.count}, пользователей: #{User.count}"
