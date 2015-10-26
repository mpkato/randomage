CSV.generate col_sep: "\t" do |csv|
  @project.elements.pluck(:gid).uniq.sort.each do |gid|
    csv << [gid, element_path(@project.name, gid, 1)]
  end
end
