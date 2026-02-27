module TeamsHelper
  def standings_row_class(rank, league)
    case league
    when 'Premier League', 'La Liga', 'Serie A', 'Bundesliga', 'Ligue 1'
      # European leagues
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
    when 'J1 League'
      # J1 League (18 teams)
      case rank
      when 1..2
        'champions-league'  # ACL spots
      when 18..20
        'relegation'
      else
        ''
      end
    when 'J2 League'
      # J2 League (22 teams)
      case rank
      when 1..2
        'promotion'  # Direct promotion
      when 3..6
        'playoff'  # Promotion playoff
      when 18..20
        'relegation'
      else
        ''
      end
    when 'J3 League'
      # J3 League
      case rank
      when 1..2
        'promotion'
      when 3..6
        'playoff'  # Promotion playoff
      when 20
        'relegation'
      else
        ''
      end
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