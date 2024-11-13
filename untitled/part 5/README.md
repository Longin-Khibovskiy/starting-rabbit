## Чтобы получить все журналы:
```ruby
ruby receive_logs_topic.rb "#"
```

## Чтобы получить все журналы с объекта `kern`:
```ruby
ruby receive_logs_topic.rb "kern.*"
```

## Или если вы хотите услышать только о `critical` журналах:
```ruby
ruby receive_logs_topic.rb "*.critical"
```

## Вы можете создать несколько привязок:
```ruby
ruby receive_logs_topic.rb "kern.*" "*.critical"
```

## И для создания журнала с `kern.critical` типом ключа маршрутизации:
```ruby
ruby emit_log_topic.rb "kern.critical" "A critical kernel error"
```