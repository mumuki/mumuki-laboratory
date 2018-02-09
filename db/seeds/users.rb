User.find_or_create_by!(uid: 'dev.student@mumuki.org') { |org| org.permissions = {student: 'central/*'} }
User.find_or_create_by!(uid: 'dev.teacher@mumuki.org') { |org| org.permissions = {teacher: 'private/*'} }
User.find_or_create_by!(uid: 'dev.owner@mumuki.org') { |org| org.permissions = {owner: '*/*'} }
