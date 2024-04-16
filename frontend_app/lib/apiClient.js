import axios from 'axios';
import cookieManager from './cookieManager';


const apiClient = axios.create({
    baseURL: '/api/'
});

function setAuthToken() {
    const account = cookieManager.getAccount();
    if (account && account.credential) {
      apiClient.defaults.headers.common['Authorization'] = `Bearer ${account.credential}`;
    }
  }

setAuthToken();

export default {
    getAssignments(courseId) {
        return apiClient.get(`/course/${courseId}/assignment`);
    },
    postAssignment(courseId, assignmentData) {
        return apiClient.post(`/course/${courseId}/assignment`, assignmentData);
    },
    getAssignment(courseId, assignmentId) {
        return apiClient.get(`/course/${courseId}/assignment/${assignmentId}`);
    },
    updateAssignment(courseId, assignmentId, assignmentData) {
        return apiClient.put(`/course/${courseId}/assignment/${assignmentId}`, assignmentData);
    },
    deleteAssignment(courseId, assignmentId) {
        return apiClient.delete(`/course/${courseId}/assignment/${assignmentId}`);
    },
    getSubmissions(courseId, assignmentId) {
        return apiClient.get(`/course/${courseId}/assignment/${assignmentId}/submission`);
    },
    getAllSubmissions(courseId, assignmentId) {
        return apiClient.get(`/course/${courseId}/assignment/${assignmentId}/submission/list_all`);
    },
    postSubmission(courseId, assignmentId, submissionData) {
        return apiClient.post(`/course/${courseId}/assignment/${assignmentId}/submission`, submissionData);
    },
    getSubmission(courseId, assignmentId, submissionId) {
        return apiClient.get(`/course/${courseId}/assignment/${assignmentId}/submission/${submissionId}`);
    },
    updateSubmission(courseId, assignmentId, submissionId, submissionData) {
        return apiClient.put(`/course/${courseId}/assignment/${assignmentId}/submission/${submissionId}`, submissionData);
    },
    deleteSubmission(courseId, assignmentId, submissionId) {
        return apiClient.delete(`/course/${courseId}/assignment/${assignmentId}/submission/${submissionId}`);
    }
};
