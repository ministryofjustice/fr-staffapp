module SummaryHelper

  def build_section(summary_text, object, fields)
    content_tag(:div, class: 'summary-section') do
      content = build_header summary_text
      fields.each do |row|
        content << build_data_row(object, row)
      end
      content
    end
  end

  private

  def build_header(summary_name)
    content_tag(:div, class: 'row') do
      content_tag(:div, class: 'small-12 medium-7 large-8 columns') do
        content_tag(:h4, "#{summary_name}")
      end
    end
  end

  def build_data_row(object, field)
    label = I18n.t("activemodel.attributes.#{object.class.name.underscore}.#{field}")
    value = object.send(field)

    rows = content_tag(:div, label, class: 'small-12 medium-5 large-4 columns subheader')
    rows << content_tag(:div, "#{value}".html_safe, class: 'small-12 medium-7 large-8 columns')

    content_tag(:div, class: 'row') do
      rows
    end
  end
end
