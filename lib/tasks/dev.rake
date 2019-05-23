namespace :dev do
  DEFAULT_FILES_PATH = File.join(Rails.root, 'lib', 'tmp')
  desc "Configura o ambiente de desenvolvimento"
  task setup: :environment do
    if Rails.env.development?
      show_spinner("Apagando BD..."){ %x(rails db:drop) }
      show_spinner("Criando BD..."){ %x(rails db:create) }
      show_spinner("Migrando BD..."){ %x(rails db:migrate) }
      show_spinner("Cadastrando ADM padrão..."){ %x(rails dev:add_default_admin) }
      show_spinner("Cadastrando ADM extra..."){ %x(rails dev:add_extra_admin) }
      show_spinner("Cadastrando USR padrão..."){ %x(rails dev:add_default_user) }
      show_spinner("Cadastrando assuntos padrões..."){ %x(rails dev:add_subjects) }
      show_spinner("Cadastrando questões padrões..."){ %x(rails dev:add_questions) }
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

  desc "Adiciona administradores extras"
  task add_extra_admin: :environment do
    10.times do |i|
      Admin.create!(
        email: Faker::Internet.email,
        password: 123456,
        password_confirmation: 123456
      )
    end
  end

  desc "Adiciona usuário padrão"
  task add_default_user: :environment do
    User.create!(
      email: 'user@user.com',
      password: 123456,
      password_confirmation: 123456
    )
  end

  desc "Adiciona assuntos padrões"
  task add_subjects: :environment do
    file_name = 'subjects.txt'
    file_path = File.join(DEFAULT_FILES_PATH, file_name)
    File.open(file_path, 'r').each do |line|
      Subject.create!(description: line.strip)
    end
  end

  desc "Adiciona perguntas e respostas"
  task add_questions: :environment do
    Subject.all.each do |subject|
      rand(5..10).times do |i|
        Question.create!(
          description: "#{Faker::Lorem.paragraph} #{Faker::Lorem.question}",
          subject: subject
        )
      end
    end
  end

  private
    def show_spinner(msg_start, msg_end = "Concluído!")
      spinner = TTY::Spinner.new("[:spinner] #{msg_start}", format: :bouncing_ball)
      spinner.auto_spin
      yield
      spinner.success("(#{msg_end})")   
    end

end