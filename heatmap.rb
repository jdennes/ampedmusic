class Heatmap
  def heatmap(histogram={})
    html = %{<div class="heatmap">}
    histogram.keys.sort{|a,b| histogram[a] <=> histogram[b]}.reverse.each do |k|
      next if histogram[k] < 1
      _max = histogram_max(histogram) * 2
      _size = element_size(histogram, k)
      _heat = element_heat(histogram[k], _max)
      html << %{
        <span class="heatmap-element" style="color: ##{_heat}#{_heat}#{_heat}; font-size: #{_size}px;">#{k}</span>
      }
    end
    html << %{<br style="clear: both;" /></div>}
  end

  def histogram_max(histogram)
    histogram.map{|k,v| histogram[k]}.max
  end

  def sum(vals)
    vals.inject(0) { |sum,item| sum + item }
  end

  def element_size(histogram, key)
    (((histogram[key] / sum(histogram.map{|k,v| histogram[k]}).to_f) * 100) + 24).to_i
  end
  
  def element_heat(val, max)
    sprintf("%02x" % (200 - ((200.0 / max) * val)))
  end
end
