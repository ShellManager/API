# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
password = SecureRandom.hex(24)
totp = ROTP::Base32.random

qr = RQRCode::QRCode.new("otpauth://totp/system%40m6.nz?secret=#{totp}&issuer=ShellManager", size: 1, level: :h)


User.create!(first_name: 'System',
            last_name: 'Administrator',
            email: 'system@m6.nz',
            date_of_birth: '1970-01-01',
            permission_level: 0,
            password: password,
            activation_token: nil,
            api_key: SecureRandom.uuid,
            activated: true,
            active: true,
            protected: true,
            user_global_id: SecureRandom.uuid,
            tfa_key: totp,
            tfa_enabled: false)
puts 'New System Account details:'
puts 'Username: root'
puts 'Email: system@m6.nz'
puts "Password: #{password}"
puts "TOTP Code: #{totp}"