class Tag < ActiveRecord::Base
  belongs_to :floor
  has_one :project
  has_many :readings, dependent: :destroy
  has_many :logs, dependent: :destroy

  def to_s
    uid
  end

  def building
    floor.building if floor
  end

  def project
    building.project if building
  end

  def data(type)
    # logs.where("datetime > " + ((Time.now.to_i - 60*60*24 - Time.now.gmtoff)*1000).to_s)
    if type == 'zone'
      logs.map { |e| [e.temp , e.humidity]}
    else
      data = []
      bulks = readings.map { |reading| reading.logs.map { |log| [log.datetime, log.attributes[type]] } }
      last = nil
      bulks.each do |bulk|
        next if bulk.empty?
        unless last.nil?
          first = bulk.first[0]
          data += [[(first+last)/2, 'NaN']]
        end
        last = bulk.last[0]
        data += bulk
      end
      data
    end
  end

  def diff_data(from, to)
    ref = project.tag
    results = []
    if ref
      ActiveRecord::Base.connection.select_all(
        ActiveRecord::Base.send(:sanitize_sql_array,
         ["select (t1.datetime/15000)*15000 as dt, (t1.pressure - t2.pressure) as dp from logs t1, logs t2 where t1.datetime/15000 = t2.datetime/15000 and t1.tag_id=? and t2.tag_id=? and t1.datetime between ? and ? order by t1.datetime;", id, ref.id, from, to])
      ).each do |record|
        # instead of an array of hashes, you could put in a custom object with attributes
        results << [record["dt"], record["dp"]]
      end
    end
    results
    # a = logs.where("datetime >= #{from} and datetime <= #{to}").map{|e| [e.datetime/15000, e.pressure]}.to_h
    # b = project.tag.logs.where("datetime >= #{from} and datetime <= #{to}").map{|e| [e.datetime/15000, e.pressure]}.to_h rescue {}
    # timespan = (a.keys + b.keys).uniq
    # output = []
    # p timespan.count, a.keys.count , b.keys.count
    # timespan.each do |t|
    #   output[t] = a[t].to_f - b[t].to_f
    # end
    # output
  end
end
