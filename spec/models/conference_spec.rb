require 'rails_helper'

RSpec.describe Conference, type: :model do
  let(:today) { Date.current }

  describe 'Бизнес-логика проверки дедлайна и статуса регистрации' do
    context 'когда дедлайн подачи заявок ещё не наступил' do
      let(:conference) { Conference.new(submission_deadline: today + 5.days) }

      it 'подтверждает, что регистрация открыта' do
        expect(conference.registration_open?).to be true
      end

      it 'корректно вычисляет оставшееся количество дней' do
        expect(conference.days_until_deadline).to eq(5)
      end
    end

    context 'когда дедлайн подачи заявок уже прошёл' do
      let(:conference) { Conference.new(submission_deadline: today - 2.days) }

      it 'показывает, что регистрация закрыта' do
        expect(conference.registration_open?).to be false
      end

      it 'возвращает 0 дней до дедлайна' do
        expect(conference.days_until_deadline).to eq(0)
      end
    end
  end

  describe 'Бизнес-логика формирования текстового бейджа индексации' do
    context 'когда конференция входит и в Scopus, и в eLibrary' do
      let(:conference) { Conference.new(is_scopus: true, is_elibrary: true) }

      it 'возвращает плашку "Scopus & eLibrary"' do
        expect(conference.indexing_badge).to eq("Scopus & eLibrary")
      end
    end

    context 'когда конференция входит только в Scopus' do
      let(:conference) { Conference.new(is_scopus: true, is_elibrary: false) }

      it 'возвращает плашку "Scopus"' do
        expect(conference.indexing_badge).to eq("Scopus")
      end
    end
  end
end
