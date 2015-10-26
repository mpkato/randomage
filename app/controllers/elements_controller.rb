class ElementsController < ApplicationController
  before_action :set_project, :set_elements, :set_draw, :set_img

  def show
    height = @project.font_size
    x = @project.offset_x
    seed_text = @seed.nil? ? " " : @seed.to_s
    @draw.annotate(@img, 0, 0, x, height + @project.offset_y, seed_text)
    @elements.each_with_index do |elem, idx|
      y = height*(idx+2) + @project.offset_y
      @draw.annotate(@img, 0, 0, x, y, elem.body)
    end
    send_data(@img.to_blob, disposition: "inline", type: "image/png")
  end

  private
    def set_project
      @project = Project.find_by(name: params[:project_name])
    end

    def set_elements
      is_random = params[:is_random] != "0"
      @seed = is_random ? rand(@project.random_num) : nil
      @elements = @project.random_elements(params[:gid], @seed)
    end

    def set_draw
      @draw = @project.get_draw
    end

    def set_img
      @img = Magick::Image.new(@project.max_width, @project.font_size*(@elements.size + 1))
      @img.format = 'png'
    end
end
