# Flutter Quiz

Тестирующее приложение для проверки знаний по Dart и Flutter.  
Архитектура: **MVVM** (Model-View-ViewModel).

---

## Функциональность

- 🧠 **15 вопросов** по темам: Dart основы, Widgets, Структура проекта, Архитектура/навигация
- 📋 **Онбординг** — 3-страничное введение при первом запуске
- 🔔 **Push-уведомления** — пользователь ставит таймер (5 мин / 30 мин / 1 ч / 3 ч / своё время)
- 📊 **Firebase Analytics** — логирование событий: `quiz_started`, `question_answered`, `quiz_finished`
- ✅ Результат с процентом правильных ответов и текстовой интерпретацией

---

## Структура проекта

```
lib/
├── main.dart                          # Точка входа, инициализация сервисов
├── models/
│   ├── question.dart                  # Модель вопроса
│   └── quiz_result.dart               # Модель результата
├── services/
│   ├── quiz_service.dart              # Загрузка вопросов из JSON
│   ├── prefs_service.dart             # SharedPreferences (онбординг)
│   ├── notification_service.dart      # Локальные push-уведомления
│   └── analytics_service.dart        # Firebase Analytics
├── view_models/
│   ├── quiz_view_model.dart           # Логика теста (MVVM ViewModel)
│   └── notification_view_model.dart   # Логика напоминаний
└── ui/
    ├── theme/app_theme.dart           # Цвета, шрифты, тема
    └── views/
        ├── onboarding_view.dart       # Онбординг (первый запуск)
        ├── home_view.dart             # Главный экран
        ├── quiz_view.dart             # Экран теста
        ├── result_view.dart           # Экран результата
        └── notification_settings_view.dart  # Настройка напоминаний

assets/
└── data/questions.json               # 15 вопросов (мок-данные)
```

---

## Запуск

```bash
# 1. Установить зависимости
flutter pub get

# 2. Запустить на эмуляторе или устройстве
flutter run

# 3. Сборка APK (отладочная)
flutter build apk --debug
```

**Минимальная версия Flutter:** 3.19.0  
**Минимальная версия Android SDK:** 21

---

## Firebase Analytics

> ⚠️ Для работы Firebase Analytics нужен файл `android/app/google-services.json`.
>
> 1. Перейдите на [console.firebase.google.com](https://console.firebase.google.com)
> 2. Создайте проект → **Добавить приложение** → Android
> 3. Package name: `com.antigravity.flutter_quiz`
> 4. Скачайте `google-services.json` и замените файл-заглушку в `android/app/`

---

## Скриншоты

| Онбординг | Главный экран | Вопрос | Результат |
|---|---|---|---|
| ![Onboarding](screenshots/onboarding.png) | ![Home](screenshots/home.png) | ![Quiz](screenshots/quiz.png) | ![Result](screenshots/result.png) |

---

## Требования оценки (100 баллов)

| Критерий | Реализация |
|---|---|
| Работоспособность на Android | ✅ minSdk 21 |
| Полный цикл теста | ✅ Онбординг → Тест → Результат |
| Подсчёт правильных ответов и % | ✅ QuizResult model |
| Слои MVVM: models / services / viewmodels / ui | ✅ |
| ViewModel инкапсулирует логику | ✅ |
| Читаемость кода | ✅ |
| Возможность расширять тесты | ✅ JSON-мок |
| JSON из assets | ✅ rootBundle |
| Обработка ошибок загрузки | ✅ QuizState.error |
| 10+ вопросов по темам | ✅ 15 вопросов |
