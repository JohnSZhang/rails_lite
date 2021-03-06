require_relative '../phase3/controller_base'
require_relative './session'

module Phase4
  class ControllerBase < Phase3::ControllerBase
    def redirect_to(url)
      self.session.store_session(@res)
      super
    end

    def render_content(content, type)
      self.session.store_session(@res)
      super
    end

    # method exposing a `Session` object
    def session
      @session ||= Session.new(@req)
    end
  end
end
