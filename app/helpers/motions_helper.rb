module MotionsHelper
  def html_attrs_for_motion(motion)
    classes = [dom_class(motion)]
    classes << 'acted_on' if member? && current_member.has_acted_on?(motion)

    { :id    => dom_id(motion), :class => classes.compact.join(' ') }
  end

  def render_motion_group(name, motion_group)
    capture_haml do
      haml_tag(:section) do
        haml_tag(:h2, t("motions.#{name}.heading"))
        if motion_group.empty?
          haml_tag('.empty', t("motions.#{name}.empty"))
        else
          haml_tag(:ul) do
            motion_group.each do |motion|
              haml_concat(render(:partial => 'motions/list_item', :locals => { :motion => motion }))
            end

            if link = link_to_more_motions(motion_group)
              haml_tag(:li, link, :class => 'no-border')
            end
          end
        end
      end
    end
  end

  def link_to_more_motions(motions)
    if motions.count > motions.size
      link_to('More', show_more_motions_path, :class => 'more_motions more-button', :'data-last-id' => motions.last.id)
    end
  end

  def motion_status_badge(motion)
    status = if motion.waitingsecond? && motion.expedited?
      'expedited'
    elsif motion.passed?
      'passed'
    elsif motion.approved?
      'approved'
    elsif motion.failed?
      'failed'
    end

    badge(status, :class => "status #{status}") unless status.blank?
  end
end
