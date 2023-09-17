module Soliton
  # Rackアプリケーション
  class Application
    def initialize(router)
      @router = router
    end

    def call(env)
      # ここで CORS などの middoleware の実行を行う
      @router.call(env)
    end
  end
end
