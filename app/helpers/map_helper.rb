module MapHelper
end
  class Time
    def gmt
      self - self.gmtoff
    end
  end
