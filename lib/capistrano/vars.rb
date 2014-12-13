@templates = {}
@executables = []
@links = []
def template template_names=[], templates
  templates = template_names.reduce(templates) do |templates, name|
    templates[name] = nil
    templates
  end
  @templates.merge templates
end
def executable exes
  @executables += templates
end
def links lnks
  @links += lnks
end
