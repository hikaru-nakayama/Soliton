module Soliton
  # Rackアプリケーション
  class Application
    def initialize(router)
      @router = router
    end

    def call(env)
      @router.call(env)
    end
  end
end
