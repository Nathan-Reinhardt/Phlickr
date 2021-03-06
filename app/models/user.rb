# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  first_name      :string           not null
#  last_name       :string           not null
#  email           :string           not null
#  age             :integer          not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  description     :string
#

class User < ApplicationRecord
    attr_reader :password
    validates :first_name, :last_name, :age, presence: true
    validate :age do
        def age_limits
            if age < 14
                errors.add(:age, "have to be 14 or up to sign up")
            end
        end
    end
    validates :email, presence: true, uniqueness: true
    validates :password_digest, presence: true
    validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
    after_initialize :ensure_session_token

    has_many :photos

    def ensure_session_token 
        self.session_token ||= SecureRandom.urlsafe_base64(16)
    end
    
    def reset_session_token
        self.session_token = SecureRandom.urlsafe_base64(16)
        self.save
        self.session_token
    end

    def password=(password)
        @password = password
        self.password_digest = BCrypt::Password.create(password)
    end

    def is_password?(password)
        BCrypt::Password.new(self.password_digest).is_password?(password)
    end

    def self.find_by_credentials(email, password)
        user = User.find_by(email: email)
        user && user.is_password?(password) ? user : nil
    end
    
end
