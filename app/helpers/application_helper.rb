# encoding: utf-8
module ApplicationHelper
  def display_base_errors resource
    return '' if (resource.errors.empty?) or (resource.errors[:base].empty?)
    messages = resource.errors[:base].map { |msg| content_tag(:p, msg) }.join
    html = <<-HTML
    <div class="alert alert-error alert-block">
      <button type="button" class="close" data-dismiss="alert">&#215;</button>
      #{messages}
    </div>
    HTML
    html.html_safe
  end
#this is the english to persian number changer
#it is made from php function
  def english_to_persian_nr(num)
   fa_num = ["۰","۱","۲","۳","۴","۵","۶","۷","۸","۹"]
   snum = num.to_s
   faarr = Array.new
   snum.split("-").each do |i|
    i.split("").each do |f|
     fint = f.to_i
     faarr.push(fa_num[fint])
   end
    faarr.push("/")
  end
  return faarr.join("")[0..-2]
 end
end
