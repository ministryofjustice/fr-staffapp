module Applications
  module Process
    class PersonalInformationsController < Applications::ProcessController
      before_action :authorize_application_update

      def index
        @form = Forms::Application::Applicant.new(application.applicant)
      end

      def create
        @form = Forms::Application::Applicant.new(application.applicant)
        @form.update_attributes(form_params(:applicant))

        if @form.save
          redirect_to redirect_to_link(@form)
        elsif @form.save
          redirect_to application_details_path
        else
          render :index
        end
      end

      private

      def redirect_to_link(form)
        return application_litigation_details_path if form.need_a_litigation_friend?
        application_details_path
      end
    end
  end
end
