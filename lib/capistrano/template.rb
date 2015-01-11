# will first try and copy the file:
# config/deploy/#{full_app_name}/#{from}.erb
# to:
# shared/config/to
# if the original source path doesn exist then it will
# search in:
# config/deploy/shared/#{from}.erb
# this allows files which are common to all enviros to
# come from a single source while allowing specific
# ones to be over-ridden
# if the target file name is the same as the source then
# the second parameter can be left out
def smart_template(from, to=nil)
  to ||= from
  full_to_path = (to.start_with? '/')? to : "#{shared_path}/config/#{to}"
  if from_erb_path = template_file(from)
    from_erb = ERB.new(File.read(from_erb_path)).result(binding)
    info "copying: #{from_erb} to: #{full_to_path}"
    upload! StringIO.new(from_erb), full_to_path
  else
    error "#{from} not found"
  end
end

def template_file(name)
  locations = %W[config/deploy/#{fetch(:full_app_name)}/#{name}.erb
                 config/deploy/shared/#{name}.erb]
  locations.reduce(nil) do |location, l| 
    location = l if File.exist? l
    location
  end
end
