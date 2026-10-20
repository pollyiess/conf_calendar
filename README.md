# 📅 ConfCalendar

Календарь научных конференций: поиск мероприятий, фильтры по индексации и городу, создание своих конференций, избранное.

## Стек
Ruby 3.4 · Rails 8.1 · SQLite · Devise · Tailwind CSS · RSpec

## Возможности
- Регистрация и вход (Devise)
- Каталог конференций с открытой подачей заявок, фильтры по индексации (Scopus / eLibrary) и городу
- Создание, редактирование и удаление своих конференций (только автор)
- Избранное и личный профиль (мои конференции + закладки)
- Автотесты: бизнес-логика моделей и сценарии пользователя

## Запуск

### Dev Container (VS Code + Docker)
1. Откройте папку проекта в VS Code → **Reopen in Container**.
2. Дождитесь установки, затем в терминале: `bin/dev`
3. Откройте http://localhost:3000

### Локально
```bash
git clone https://github.com/pollyiess/conf_calendar.git
cd conf_calendar
bundle install
bin/rails db:prepare
bin/dev
```
Демо-аккаунты: `demo@example.com` и `demo2@example.com`, пароль `password123`.

## Тесты
```bash
bundle exec rspec
```

## Планы
Рекомендательная система конференций.