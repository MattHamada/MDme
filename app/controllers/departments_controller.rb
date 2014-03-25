class DepartmentsController < ApplicationController

  def index
   @departments = current_admin.clinic_departments
  end

  def new
   @department = Department.new
  end

  def create
    @department = Department.new(department_params)
    @department.clinic_id = current_admin.clinic_id

    if @department.save
      flash[:success] = 'Department Successfully Created.'
      redirect_to departments_path
    else
      render 'new'
    end

  end

  def show
   @department = department
   @doctors = @department.doctors.in_clinic(@department)
  end

  def edit

  end

  def update

  end

  def destroy
    @department = department
    if @department.doctors.empty?
      @department.destroy
      flash[:notice] = 'Department deleted'
      redirect_to departments_path
    else
      flash[:danger] = 'Cannot delete a department with doctors'
      redirect_to department_path(@department)
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
end

