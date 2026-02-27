module TeamsHelper
  def standings_row_class(rank)
    case rank
    when 1..4
      'champions-league'
    when 5
      'europa-league'
    when 6
      'conference-league'
    when 18..20
      'relegation'
    else
      ''
    end
  end
  
  def render_form(form_string)
    return '' unless form_string.present?
    
    form_string.chars.map do |result|
      case result
      when 'W'
        content_tag(:span, 'W', class: 'badge bg-success me-1', style: 'font-size: 0.7rem;')
      when 'D'
        content_tag(:span, 'D', class: 'badge bg-secondary me-1', style: 'font-size: 0.7rem;')
      when 'L'
        content_tag(:span, 'L', class: 'badge bg-danger me-1', style: 'font-size: 0.7rem;')
      else
        ''
      end
    end.join.html_safe
  end
end