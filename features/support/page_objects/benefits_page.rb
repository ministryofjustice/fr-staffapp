class BenefitsPage < BasePage
  set_url '/applications/2/benefits'

  section :content, '#content' do
    element :header, 'h2', text: 'Benefits'
    element :no, '.block-label', text: 'No'
    element :yes, '.block-label', text: 'Yes'
  end

  def submit_benefits_yes
    content.yes.click
    next_page
  end

  def submit_benefits_no
    content.no.click
    next_page
  end
end
