namespace :dev do
  desc "Configura o ambiente de desenvolvimento"
  task setup: :environment do
    if Rails.env.development?
      show_spinner("Apagando BD..."){ %x(rails db:drop) }
      show_spinner("Criando BD..."){ %x(rails db:create) }
      show_spinner("Migrando BD..."){ %x(rails db:migrate) }
      show_spinner("Cadastrando ADM padrão..."){ %x(rails dev:add_default_admin) }
      show_spinner("Cadastrando USR padrão..."){ %x(rails dev:add_default_user) }      
    else
      puts 'Não está em modo desenvolvimento'
    end
  end

  desc "Adiciona administrador padrão"
  task add_default_admin: :environment do
    Admin.create!(
      email: 'admin@admin.com',
      password: 123456,
      password_confirmation: 123456
    )
  end

  desc "Adiciona usuário padrão"
  task add_default_user: :environment do
    User.create!(
      email: 'user@user.com',
      password: 123456,
      password_confirmation: 123456
    )
  end

  private
    def show_spinner(msg_start, msg_end = "Concluído!")
      spinner = TTY::Spinner.new("[:spinner] #{msg_start}", format: :bouncing_ball)
      spinner.auto_spin
      yield
      spinner.success("(#{msg_end})")   
    end

end