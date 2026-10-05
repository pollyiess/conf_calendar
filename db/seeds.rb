Conference.destroy_all

Conference.create!([
  {
    title: "International Conference on Software Engineering & AI 2026",
    description: "Международная научно-практическая конференция, посвящённая современным методам искусственного интеллекта и программной инженерии.",
    start_date: "2026-12-12",
    end_date: "2026-12-14",
    submission_deadline: "2026-11-15",
    location: "Москва, Россия",
    website_url: "https://example.com/icseai2026",
    is_scopus: true,
    is_elibrary: true,
    status: :published
  },
  {
    title: "Всероссийский симпозиум по высокопроизводительным вычислениям",
    description: "Обсуждение актуальных вопросов суперкомпьютерных технологий, параллельного программирования и обработки больших данных.",
    start_date: "2026-10-20",
    end_date: "2026-10-22",
    submission_deadline: "2026-10-10",
    location: "Санкт-Петербург, Россия",
    website_url: "https://example.com/hpc2026",
    is_scopus: false,
    is_elibrary: true,
    status: :published
  },
  {
    title: "Конференция по кибербезопасности и сетевым технологиям",
    description: "Ежегодный форум исследователей и практиков в сфере информационной безопасности, криптографии и защиты данных.",
    start_date: "2026-11-05",
    end_date: "2026-11-07",
    submission_deadline: "2026-10-25",
    location: "Казань, Россия",
    website_url: "https://example.com/cybersec2026",
    is_scopus: true,
    is_elibrary: false,
    status: :published
  }
])

puts "Создано конференций: #{Conference.count}"
