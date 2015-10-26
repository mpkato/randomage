CSV.generate col_sep: "\t" do |csv|
  @project.elements.pluck(:gid).uniq.sort.each do |gid|
    @project.random_num.times do |i|
      elements = @project.random_elements(gid, i)
      elements.each_with_index do |elem, idx|
        csv << [gid, i, idx+1, elem.eid]
      end
    end
  end
end
