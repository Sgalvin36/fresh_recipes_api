class AddInstructionStepToRecipeInstructions < ActiveRecord::Migration[7.1]
  def change
    add_column :recipe_instructions, :instruction_step, :integer
  end
end
