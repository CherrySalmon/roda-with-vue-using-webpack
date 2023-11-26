<template>
  <el-container class="todo-list">
    <FileUpload></FileUpload>
    <el-header>
      <h1>Todo List</h1>
    </el-header>
  
    <el-main>
    
      <el-row class="form">
      
        <el-col :xs="24" :sm="16">
          <el-input v-model="newTodoText" placeholder="Add todo"/>
        </el-col>
        
        <el-col :xs="24" :sm="8">
          <el-date-picker 
            v-model="dueDate"
            type="datetime"
            placeholder="Pick a due date"/>
        </el-col>
        
        <el-col :xs="24">
          <el-button 
            type="primary" 
            round
            @click="addTodo">
            Add
          </el-button>
        </el-col>
        
      </el-row>
      
      <el-row class="todos">
      
        <el-col 
          v-for="todo in todos" 
          :key="todo.id"
          :xs="24"
          :sm="12"
          :md="8"
          :lg="6">
        
          <el-card shadow="hover" class="todo-card">
          
            <el-checkbox v-model="todo.completed"/>
            
            <div 
              :class="{'is-completed': todo.completed}">
              {{ todo.name }}
            </div>
          
            <el-tooltip content="Due date" placement="top">
              <div class="due-date">
                {{ todo.due_date }}
              </div>
            </el-tooltip>
            
            <el-button
              type="danger"
              icon="el-icon-delete"
              circle
              @click="removeTodo(todo)"/>
            
          </el-card>
          
        </el-col>
        
      </el-row>
      
    </el-main>
  
  </el-container>
  
</template>

<script>
import { 
  ElContainer,
  ElHeader,
  ElMain,
  ElForm,
  ElRow, 
  ElCol,
  ElInput,
  ElDatePicker,
  ElButton,
  ElCheckbox, 
  ElTooltip
} from 'element-plus'
import axios from 'axios'
import FileUpload from '../components/FileUpload.vue'

export default {

  components: {
    ElContainer,
    ElHeader,
    ElMain,
    ElForm,
    ElRow,
    ElCol,
    ElInput,
    ElDatePicker,
    ElButton,
    ElCheckbox,
    ElTooltip,
    FileUpload
  },

  data() {
    return {
      newTodoText: '',
      dueDate: null,
      todos: []
    }
  },

  methods: {
    async addTodo() {
      const response = await axios.post('/todos', {
        name: this.newTodoText,
        due_date: this.dueDate || null
      })
      this.todos.push(response.data)
      this.newTodoText = ''
      this.dueDate = ''
      this.fetchTodos()
    },
    async removeTodo(todo) {
    await axios.delete(`/todos/${todo.id}`)
    this.todos = this.todos.filter(t => t.id !== todo.id)
    },
    
    async fetchTodos() {
      const response = await axios.get('/todos')
      this.todos = response.data.data.map(todo => todo.data.attributes)  
    }
  },
  
  created() {
    this.fetchTodos()
  }
  
}
</script>

<style>
/* Element Plus default styles */

.due-date {
  color: #999;
  font-size: 14px; 
}

.is-completed {
  text-decoration: line-through;
  color: #999;
}

.todo-list {
  max-width: 800px;
  margin: 0 auto;
}

.form {
  margin-bottom: 20px;
}

.todo-card {
  padding: 20px;
  margin-bottom: 20px;
}


</style>
