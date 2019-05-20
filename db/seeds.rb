# frozen_string_literal: true

if Rails.env.development?
  User.create(
    email: 'nguyentatnam53ac@gmail.com',
    name: 'Nguyễn Tất Nam',
    password: 'nam123456',
    is_admin: true
  )
end
