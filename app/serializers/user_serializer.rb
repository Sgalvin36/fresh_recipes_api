class UserSerializer
    include JSONAPI::Serializer
    attributes :name, :username, :key

    def self.format_user_list(users)
        { data:
            users.map do |user|
                {
                id: user.id.to_s,
                type: "user",
                attributes: {
                    name: user.name,
                    username: user.username
                }
                }
            end
        }
    end

    def self.format_detailed_user(user)
        { data: {
            id: user.id.to_s,
            type: "user",
            attributes: {
                name: user.name,
                username: user.username
            }
            }
        }
    end
end