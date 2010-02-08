module EmployeeHelper


def subordinates_tree(employee, options = {})
  case options[:format]
    when "html" then subordinates_tree_html(employee, options)
    when "json" then subordinates_tree_json(employee, options)
    else raise RuntimeError, "Unknown format: #{options[:format]}"
  end
end

# Generate a simple ul/li tree of employees and their subordinates
def subordinates_tree_html(employee, options ={})
  
  options[:indent] ? indent = options[:indent] : indent = 1
  options[:max_depth] ? max_depth = options[:max_depth] : max_depth = 0
  options[:display_depth] ? display_depth = options[:display_depth] : display_depth = 1000
  options[:depth] ? depth = options[:depth] : depth = 0
  options[:root] ? root = true : root = false
  
  tree = ""
  
  if root
    indent!(tree, indent)
    tree << "<ul>\n"
    indent += 1 
  end

  if employee.subordinates.length > 0

    depth += 1

    indent!(tree, indent)
    tree << "<li>#{employee.name}\n" 
    indent += 1 

    indent!(tree, indent)

    if display_depth > depth
      tree << "<ul>\n"
    else 
      tree << "<ul style=\"display: none\">\n"
    end
    indent += 1 

    employee.subordinates.sort_by { |e| e.last_name }.each do |s|
      tree << subordinates_tree_html(s, options = {:indent => indent, :depth => depth , :display_depth => display_depth})
    end

    indent -= 1 
    indent!(tree, indent)
    tree << "</ul>\n"

    indent -= 1 
    indent!(tree, indent)
    tree << "</li>\n"

  else 

    indent!(tree, indent)
    if display_depth > depth
      tree << "<li>#{employee.name}</li>\n"
    else 
      tree << "<li style=\"display: none\">#{employee.name}</li>\n"
    end 

  end

  if root
    indent -= 1
    indent!(tree, indent)
    tree << "</ul>\n"
  end

  tree
end

def subordinates_tree_json(employee, options = {})  
  
end

def indent!(text, depth)
  tab = "  "
  depth.times { text << tab }
end

end
