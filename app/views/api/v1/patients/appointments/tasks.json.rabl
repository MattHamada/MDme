object false
extends 'api/v1/success_header'

child :data do
node(:tasks) { @tasks }
end