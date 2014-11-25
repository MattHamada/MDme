# MDme Rails master application
# Author:: Matt Hamada (maito:mattahamada@gmail.com)
# 3/29/14
# Copyright:: Copyright (c) 2014 MDme
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential.

# <tt>Admins::DepartmentsController</tt>
# for admin.mdme.us/admins/:admin_id/departments
class Admins::DepartmentsController < ApplicationController

  before_filter :find_admin
  before_filter :require_admin_login

  # GET admin.mdme.us/admins/:admin_id/departments
  def index
    @departments = @admin.clinic_departments
  end

  # GET admin.mdme.us/admins/:admin_id/departments/new
  def new
    @department = Department.new
  end

  # POST admin.mdme.us/admins/:admin_id/departments
  def create
    @department = Department.new(department_params)
    @department.clinic_id = current_admin.clinic_id

    if @department.save
      flash[:success] = 'Department Successfully Created.'
      redirect_to admin_departments_path(@admin)
    else
      render 'new'
    end

  end

  # GET admin.mdme.us/admins/:admin_id/departments/:id
  def show
    @department = department
    @doctors = @department.doctors.in_clinic(@department)
  end

  # GET admin.mdme.us/admins/:admin_id/departments/:id/edit
  def edit
  end

  # PATCH admin.mdme.us/admins/:admin_id/departments/:id
  def update
  end

  # DELETE admin.mdme.us/admins/:admin_id/departments/:id
  def destroy
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

  private
    def department_params
      params.require(:department).permit(:name)
    end

    def department
      @department ||= Department.find_by_slug!(params[:id])
    end
    helper_method :department

    def find_admin
      @admin ||= Admin.find(params[:admin_id])
    end
    helper_method :find_admin
end