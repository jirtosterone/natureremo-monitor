require 'logger'
require 'json'
require 'net/http'


module Script
  # Loggerパラメータ
  LOGGER_DT_FORMAT = '%Y-%m-%dT%H:%M:%SZ'
  LOGGER_DEST = STDOUT
  LOGGER_LEVEL = Logger::INFO


  class RemoApi
    # データ取得準備
    def initialize
      # Logger初期化
      @logger = Logger.new(LOGGER_DEST)
      @logger.level = LOGGER_LEVEL
      @logger.datetime_format = LOGGER_DT_FORMAT

      # Data初期化
      @data = nil

      # Remoへの接続識別子
      conf = JSON.load_file(File.join(__dir__, 'remo.json'))
      @logger.debug("Conf: #{conf}")

      uri = URI.parse(conf['remo']['uri'])
      @logger.debug("URI: #{uri}")

      # HTTPオブジェクト生成
      @http = Net::HTTP.new(uri.host, uri.port)
      @http.use_ssl = uri.scheme === 'https'
      @logger.debug("Http obj: #{@http.inspect}")

      # Requestオブジェクト生成
      @request = Net::HTTP::Get.new(uri.request_uri)
      @request['Authorization'] = conf['remo']['auth']
      @request['accept'] = conf['remo']['accept']
      @logger.debug("Req obj: #{@request.inspect}")

      @logger.info('Initialized.')
    end

    # Remoに登録したデバイスの最新データを取得
    def get_newest_data
      # Remoからデータを取得
      response = @http.request(@request)
      code = response.code.to_i
      @data = JSON.load(response.body)
      @logger.debug("Code: #{code}")
      @logger.debug("Body: #{@data}")

      if code != 200 then
        @logger.error("Request error: Code: #{code}, Body: #{@data}")
      end

      @logger.info('Got data.')
    end

    # RemoデータをDBにINSERT
    def insert_data
      # タイムゾーンに基づく現在時刻を取得
      now = Time.now()
      @logger.debug("Current time: #{now}")

      # Deviceごとにデータを登録
      @data.each do |d|
        @logger.debug("Insert data: #{d}")

        # 最新データを抽出
        ne = d['newest_events']
        @logger.debug("Newest event: #{ne}")

        event = nil
        device = Device.find_by device_id: d['id']
        if d['firmware_version'].include?('mini') then
          # miniデータ
          event = Event.new(
            device: device,
            event_datetime: now,
            temparature: ne['te']['val']
          )
        else
          # 通常データ
          event = Event.new(
            device: device,
            event_datetime: now,
            temparature: ne['te']['val'],
            humidity:ne['hu']['val'],
            illumination: ne['il']['val'],
            movement: ne['mo']['val']
          )
        end
        @logger.debug("Record: #{event}")

        # DBにデータを追加
        ret = event.save()
      end

      @logger.info('Inserted data.')
    end
  end

end

remo = Script::RemoApi.new
remo.get_newest_data
remo.insert_data
