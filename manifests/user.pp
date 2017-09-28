#
# Class base::user to create users
#

class base::user (
  $users = {}
){
  create_resources( 'user' , $users )
}
