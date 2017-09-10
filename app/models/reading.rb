class Reading < ActiveRecord::Base
  belongs_to :tag
  has_many :logs, dependent: :destroy

  def self.default_scope
    order(:time, :offset)
  end

  def to_s
    "#{tag}-#{id}"
  end

  def interprete_all
    logs.delete_all
    temps = data.chars.each_slice(8).map &:join
    temps.each_with_index do |temp, index|
      next if temp == "00000000"
      temp_val, hum_val = temp.chars.each_slice(4).map(&:join).map &:hex
      next if hum_val == 0
      next if temp_val == 0
      temp = -46.85 + ((175.72*temp_val)/65536)
      rh = ((125.0 * hum_val)/65536) - 6
      _time = time + (index+offset/4)*log_interval*1000
      _time = _time/15000*15000 # rounding to every 15 seconds

      at = temp + 273.15
      e = Math.exp(-2836.5744*at**-2-6028.076559*at**-1+19.54263612-0.02737830188*at+0.000016261698*at**2+0.00000000070229056*at**3-1.8680009*10**-13*at**4+2.7150305*Math.log(at))
      p = rh*e/100

      logs.create tag: tag, temp: temp, humidity: rh, datetime: _time, pressure: p
    end
    true
  end

  def interprete(yielder)
    logs.delete_all
    temps = data.chars.each_slice(8).map &:join
    temps.each_with_index do |temp, index|
      next if temp == "00000000"
      temp_val, hum_val = temp.chars.each_slice(4).map(&:join).map &:hex
      next if hum_val == 0
      next if temp_val == 0
      temp = -46.85 + ((175.72*temp_val)/65536)
      rh = ((125.0 * hum_val)/65536) - 6
      _time = time + (index+offset/4)*log_interval*1000
      _time = _time/15000*15000 # rounding to every 15 seconds

      at = temp + 273.15
      e = Math.exp(-2836.5744*at**-2-6028.076559*at**-1+19.54263612-0.02737830188*at+0.000016261698*at**2+0.00000000070229056*at**3-1.8680009*10**-13*at**4+2.7150305*Math.log(at))
      p = rh*e/100

      logs.create tag: tag, temp: temp, humidity: rh, datetime: _time, pressure: p
      yielder << '.'
    end
    true
  end
end
