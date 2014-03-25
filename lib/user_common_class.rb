module UserCommonClass

  def in_clinic(model)
    if model.is_a?(self)
      self.where(clinic_id: model.clinic_id).where.not(id: model.id)
    else
      self.where(clinic_id: model.clinic_id)
    end
  end

end