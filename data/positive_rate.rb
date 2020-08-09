require 'csv'
require 'json'
require 'date'

csv_data = CSV.read('岩手県 コロナ情報 - 検査件数・検査の陽性率.csv', headers: true)
as_of = Date.parse(ARGV[0]) || Date.today

class InspectionInfo
  ANTIGEN_INSPECTION_SINCE = Date.parse('2020-06-19').freeze

  def initialize(csv_row)
    @csv_row = csv_row
  end

  def date
    @date ||= Date.parse(date_as_string)
  end

  def to_h
    {
      diagnosed_date: date,
      positive_count: positive_count,
      negative_count: negative_count,
      pcr_positive_count: pcr_positive_count,
      antigen_positive_count: antigen_positive_count,
      pcr_negative_count: pcr_negative_count,
      antigen_negative_count: antigen_negative_count,
      weekly_average_diagnosed_count: weekly_average_diagnosed_count,
      positive_rate: positive_rate
    }
  end

  private

  attr_reader :csv_row

  def diagnosed_date
    date_as_string
  end

  def date_as_string
    csv_row['日付']
  end

  def positive_count
    csv_row['陽性者数 合計'].to_i
  end

  def negative_count
    csv_row['陰性者数 合計'].to_i
  end

  # @note 「PCR検査陽性者数」として表示される
  def pcr_positive_count
    csv_row['PCR検査 陽性者数'].to_i
  end

  # @note 「抗原検査陽性者数」として表示される
  def antigen_positive_count
    execute_antigen_inspection? ? csv_row['抗原検査 陽性者数'].to_i : nil
  end

  # @note 「PCR検査陰性者数」として表示される
  def pcr_negative_count
    csv_row['PCR検査 陰性者数'].to_i
  end

  # @note 「抗原検査陰性者数」として表示される
  def antigen_negative_count
    execute_antigen_inspection? ? csv_row['抗原検査 陰性者数'].to_i : nil
  end

  # @note 「検査件数（７日間移動平均）」として表示される
  def weekly_average_diagnosed_count
    in_row = csv_row['検査件数（7日間移動平均）']
    in_row ? in_row.to_f : nil
  end

  # @note 「陽性率」として表示される
  def positive_rate
    in_row = csv_row['陽性率']
    in_row ? in_row.to_f : nil
  end

  def execute_antigen_inspection?
    ANTIGEN_INSPECTION_SINCE <= date
  end
end

inspection_infos = csv_data.
                   map { |row| InspectionInfo.new(row) }.
                   select { |row| row.date < as_of }.
                   sort_by(&:date).
                   map(&:to_h)

File.open('positive_rate.json', 'w:utf-8') do |file|
  file.puts(JSON.pretty_generate({
    date: "#{as_of.strftime('%Y-%m-%d')} 10:00",
    data: inspection_infos
  }))
end
