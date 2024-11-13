## Если вы хотите сохранить в файл только сообщения журнала «предупреждения» и «ошибки» (но не «информацию»), просто откройте консоль и введите: ##
```angular2html
ruby receive_logs_direct.rb warning error > logs_from_rabbit.log
```
## Если вы хотите увидеть все сообщения журнала на экране, откройте новый терминал и выполните: ##
```ruby
ruby receive_logs_direct.rb info warning error
# => [*] Waiting for logs. To exit press CTRL+C
```
## А, например, чтобы вывести ```Error``` сообщение журнала, просто введите: ##
```ruby
ruby emit_log_direct.rb error "Run. Run. Or it will explode."
# => [x] Sent 'error':'Run. Run. Or it will explode.'
```