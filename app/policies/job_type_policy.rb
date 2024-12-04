class JobTypePolicy < ApplicationPolicy
  def create?
    user.admin? 
  end

  def update?
    user.admin?
  end

  def destroy?
    user.admin?
  end

  def training_module?
    true 
  end

  def complete_training?
    true 
  end
end
