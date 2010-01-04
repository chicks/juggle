module EmployeeHelper

# Generate a simple ul/li tree of employees and their subordinates
def subordinates_tree(employee, options={})
  
  options[:indent] ? indent = options[:indent] : indent = 1
  options[:max_depth] ? max_depth = options[:max_depth] : max_depth = 0

  tree = ""

  indent!(tree, indent)
  tree << "<ul>\n" 
  indent += 1

  if employee.subordinates.length > 0

    indent!(tree, indent)
    tree << "<li>#{employee.name}\n" 

    employee.subordinates.each do |s|
      tree << subordinates_tree(s, options = {:indent => indent.next })
    end

    indent!(tree, indent)
    tree << "</li>\n"

  else 

    indent!(tree, indent)
    tree << "<li>#{employee.name}</li>\n"

  end

  indent -= 1
  indent!(tree, indent)
  tree << "</ul>\n" 

  return tree

end

def indent!(text, depth)
  tab = "  "
  depth.times { text << tab }
end

end
