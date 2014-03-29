class Admins::DepartmentsController < ApplicationController

  def index
    @admin = admin
    @departments = current_admin.clinic_departments
  end

  def new
    @admin = admin
    @department = Department.new
  end

  def create
    @admin = admin
    @department = Department.new(department_params)
    @department.clinic_id = current_admin.clinic_id

    if @department.save
      flash[:success] = 'Department Successfully Created.'
      redirect_to admin_departments_path(@admin)
    else
      render 'new'
    end

  end

  def show
    @admin = admin
    @department = department
    @doctors = @department.doctors.in_clinic(@department)
  end

  def edit
    @admin = admin
  end

  def update
    @admin = admin
  end

  def destroy
    @admin = admin
    @department = department
    if @department.doctors.empty?
      @department.destroy
      flash[:notice] = 'Department deleted'
      redirect_to admin_departments_path(@admin)
    else
      flash[:danger] = 'Cannot delete a department with doctors'
      redirect_to admin_department_path(@admin, @department)
    end

  end

  def department_params
    params.require(:department).permit(:name)
  end

  private
  def department
    @department ||= Department.find_by_slug!(params[:id])
  end
  helper_method :department

  def admin
    @admin ||= Admin.find(params[:admin_id])
  end
  helper_method :admin
end